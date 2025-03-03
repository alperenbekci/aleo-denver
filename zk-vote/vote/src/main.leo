// The 'voting' program.
program voting.aleo {
    // Oy verme durumunu temsil eden kayıt
    record Vote {
        owner: address,
        candidate: u32,
        weight: u32,
        has_voted: bool,
    }

    struct VoterInfo {
        candidate: u32,
        weight: u32,
        has_voted: bool,
    }

    // Toplam oyları tutan mapping
    mapping vote_counts: u32 => u32;
    mapping voter_status: address => VoterInfo;

    // Oy sayısını güncelleme
    async function update_vote_count(candidate: u32, weight: u32) -> Future {
        let current_count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        Mapping::set(vote_counts, candidate, current_count + weight);
        return Future();
    }

    // Voter status güncelleme
    async function update_voter_status(voter: address, info: VoterInfo) -> Future {
        Mapping::set(voter_status, voter, info);
        return Future();
    }

    // Oy verme fonksiyonu
    async transition cast_vote(
        public candidate: u32,
        public weight: u32,
    ) -> (Vote, Future) {
        // Oy verenin adresi
        let voter: address = self.caller;
        
        // Oy ağırlığının geçerli olduğunu kontrol et (1 ile 10 arası)
        assert(weight >= 1u32);
        assert(weight <= 10u32);
        
        // Yeni oyu kaydet
        let new_vote: Vote = Vote {
            owner: voter,
            candidate: candidate,
            weight: weight,
            has_voted: true,
        };
        
        // Voter info oluştur
        let voter_info: VoterInfo = VoterInfo {
            candidate: candidate,
            weight: weight,
            has_voted: true,
        };

        // Oy sayısını güncelle
        let update_count_future: Future = update_vote_count(candidate, weight);
        
        // Voter status'u güncelle
        let update_status_future: Future = update_voter_status(voter, voter_info);

        // Oy kaydını ve Future'ı döndür
        return (new_vote, await_futures(update_count_future, update_status_future));
    }

    // Adayın oy sayısını görüntüleme fonksiyonu
    transition get_vote_count(public candidate: u32) -> u32 {
        return Mapping::get_or_use(vote_counts, candidate, 0u32);
    }

    // Kullanıcının oy kullanıp kullanmadığını kontrol etme
    transition check_voter_status(voter: address) -> bool {
        let voter_info: VoterInfo = Mapping::get_or_use(voter_status, voter, VoterInfo {
            candidate: 0u32,
            weight: 0u32,
            has_voted: false,
        });
        return voter_info.has_voted;
    }
} 