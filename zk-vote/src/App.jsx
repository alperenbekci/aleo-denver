import React, { useState, useEffect } from 'react';
import { useWallet } from '@demox-labs/aleo-wallet-adapter-react';
import "./App.css";
import helloworld_program from "../helloworld/build/main.aleo?raw";
import { AleoWorker } from "./workers/AleoWorker.js";

const aleoWorker = AleoWorker();

function App() {
  const { wallet, connected } = useWallet();
  const [candidates, setCandidates] = useState([
    { id: 1, name: "Aday 1", voteCount: 0 },
    { id: 2, name: "Aday 2", voteCount: 0 },
    { id: 3, name: "Aday 3", voteCount: 0 }
  ]);
  const [loading, setLoading] = useState(false);

  const castVote = async (candidateId) => {
    if (!connected || !wallet) {
      alert("Lütfen cüzdanınızı bağlayın!");
      return;
    }

    try {
      setLoading(true);
      
      // Oy verme işlemi için kontrat çağrısı
      const transaction = await wallet.requestTransaction({
        program: "voting.aleo",
        function: "cast_vote",
        inputs: [candidateId.toString(), "1"]
      });

      console.log("Transaction:", transaction);
      
      // UI'ı güncelle
      setCandidates(prev => 
        prev.map(c => 
          c.id === candidateId 
            ? {...c, voteCount: c.voteCount + 1}
            : c
        )
      );
    } catch (error) {
      console.error("Oy verme hatası:", error);
      alert("Oy verme işlemi başarısız oldu!");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100 py-6 flex flex-col justify-center sm:py-12">
      <div className="relative py-3 sm:max-w-xl sm:mx-auto">
        <div className="absolute inset-0 bg-gradient-to-r from-cyan-400 to-light-blue-500 shadow-lg transform -skew-y-6 sm:skew-y-0 sm:-rotate-6 sm:rounded-3xl"></div>
        <div className="relative px-4 py-10 bg-white shadow-lg sm:rounded-3xl sm:p-20">
          <div className="max-w-md mx-auto">
            <div className="divide-y divide-gray-200">
              <div className="py-8 text-base leading-6 space-y-4 text-gray-700 sm:text-lg sm:leading-7">
                <h1 className="text-3xl font-bold mb-8 text-center">ZK Voting</h1>
                
                {!connected && (
                  <div className="text-center mb-8">
                    <button
                      onClick={() => wallet?.connect()}
                      className="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600"
                    >
                      Cüzdanı Bağla
                    </button>
                  </div>
                )}

                <div className="space-y-4">
                  {candidates.map((candidate) => (
                    <div key={candidate.id} className="border p-4 rounded-lg">
                      <h3 className="text-xl font-semibold">{candidate.name}</h3>
                      <p className="text-gray-600">Oy Sayısı: {candidate.voteCount}</p>
                      <button
                        onClick={() => castVote(candidate.id)}
                        disabled={!connected || loading}
                        className="mt-2 bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 disabled:bg-gray-400"
                      >
                        {loading ? "İşlem Yapılıyor..." : "Oy Ver"}
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
