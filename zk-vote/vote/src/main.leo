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

    // Oy sayısını ve voter durumunu güncelleme
    async function update_vote(candidate: u32, weight: u32, voter: address, info: VoterInfo) {
        let current_count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        Mapping::set(vote_counts, candidate, current_count + weight);
        Mapping::set(voter_status, voter, info);
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

        // Oy sayısını ve voter durumunu güncelle
        let update_future: Future = update_vote(candidate, weight, voter, voter_info);

        // Oy kaydını ve Future'ı döndür
        return (new_vote, update_future);
    }

    // Adayın oy sayısını görüntüleme fonksiyonu
    async function get_candidate_votes(candidate: u32) {
        let count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        return count;
    }

    async transition get_vote_count(public candidate: u32) -> (u32, Future) {
        let count: u32 = Mapping::get_or_use(vote_counts, candidate, 0u32);
        let get_votes_future: Future = get_candidate_votes(candidate);
        return (count, get_votes_future);
    }

    // Voter durumunu kontrol etme
    async function get_voter_info(voter: address) {
        let info: VoterInfo = Mapping::get_or_use(voter_status, voter, VoterInfo {
            candidate: 0u32,
            weight: 0u32,
            has_voted: false,
        });
        return info;
    }

    async transition check_voter_status(voter: address) -> (bool, Future) {
        let info: VoterInfo = Mapping::get_or_use(voter_status, voter, VoterInfo {
            candidate: 0u32,
            weight: 0u32,
            has_voted: false,
        });
        let get_info_future: Future = get_voter_info(voter);
        return (info.has_voted, get_info_future);
    }
} 