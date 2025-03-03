// The 'voting' program.
program voting.aleo {
    // Oy verme durumunu temsil eden kayıt
    record Vote {
        owner: address,
        candidate: u32,
        weight: u32,
        has_voted: bool,
    }

    // Toplam oyları tutan mapping
    mapping vote_counts: u32 => u32;

    // Oy verme fonksiyonu
    transition cast_vote(
        public candidate: u32,
        public weight: u32,
    ) -> Vote {
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
        
        // Mevcut oy sayısını al ve güncelle
        let current_count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        Mapping::set(vote_counts, candidate, current_count + weight);

        // Oy kaydını döndür
        return new_vote;
    }

    // Adayın oy sayısını görüntüleme fonksiyonu
    transition get_vote_count(public candidate: u32) -> u32 {
        return Mapping::get_or_use(vote_counts, candidate, 0u32);
    }

    // Oy sayısını güncelleme yardımcı fonksiyonu
    function update_vote_count(
        candidate: u32,
        weight: u32
    ) -> u32 {
        let current_count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        return current_count + weight;
    }

    // Kullanıcının oy kullanıp kullanmadığını kontrol etme
    transition check_voter_status(voter: address) -> bool {
        let vote_status: Vote = votes.get_or_use(voter, Vote {
            candidate: 0u32,
            weight: 0u32,
            has_voted: false,
        });
        return vote_status.has_voted;
    }
} 