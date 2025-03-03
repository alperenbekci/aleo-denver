program voting.aleo {
    // Oy verme durumunu temsil eden yapı
    struct Vote {
        candidate: u32,
        weight: u32,
    }

    // Oy kaydını tutan mapping
    mapping votes: address => Vote;
    
    // Toplam oyları tutan mapping
    mapping vote_counts: u32 => u32;

    // Oy verme fonksiyonu
    transition cast_vote(candidate: u32, weight: u32) {
        // Oy verenin adresi
        let voter: address = self.caller;
        
        // Yeni oyu kaydet
        let new_vote: Vote = Vote {
            candidate: candidate,
            weight: weight,
        };
        
        // Oyu kaydet
        votes.set(voter, new_vote);
        
        // Mevcut oy sayısını al
        let current_count: u32 = vote_counts.get_or_use(candidate, 0u32);
        
        // Oy sayısını güncelle
        vote_counts.set(candidate, current_count + weight);
    }

    // Adayın oy sayısını görüntüleme fonksiyonu
    transition get_vote_count(candidate: u32) -> u32 {
        return vote_counts.get_or_use(candidate, 0u32);
    }
} 