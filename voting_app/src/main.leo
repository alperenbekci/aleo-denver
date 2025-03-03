// The 'voting_app' program.
program voting_app.aleo {
    // Oylama yapısı
    struct Poll {
        id: u32,
        creator: address,
        yes_votes: u32,
        no_votes: u32,
        is_active: bool,
    }

    // Oylama kaydını tutan mapping
    mapping polls: u32 => Poll;
    
    // Kullanıcıların oy kullanıp kullanmadığını takip eden mapping
    mapping has_voted: field => bool;

    // Yeni bir oylama başlatma
    transition create_poll(poll_id: u32) -> Poll {
        let new_poll: Poll = Poll {
            id: poll_id,
            creator: self.caller,
            yes_votes: 0u32,
            no_votes: 0u32,
            is_active: true,
        };

        return new_poll;
    }

    finalize create_poll(poll_id: u32, new_poll: Poll) {
        polls.set(poll_id, new_poll);
    }

    // Oy kullanma
    transition vote(poll_id: u32, vote_value: bool) {
        let voter_key: field = BHP256::hash_to_field(self.caller);
        return;
    }

    finalize vote(poll_id: u32, vote_value: bool, voter_key: field) {
        let poll: Poll = polls.get_or_use(poll_id, Poll {
            id: 0u32,
            creator: aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq0g,
            yes_votes: 0u32,
            no_votes: 0u32,
            is_active: false,
        });
        assert(poll.is_active);

        let has_voted_before: bool = has_voted.get_or_use(voter_key, false);
        assert(!has_voted_before);

        if vote_value {
            poll.yes_votes += 1u32;
        } else {
            poll.no_votes += 1u32;
        }

        polls.set(poll_id, poll);
        has_voted.set(voter_key, true);
    }

    // Oylamayı sonlandırma
    transition end_poll(poll_id: u32) -> Poll {
        let poll: Poll = polls.get_or_use(poll_id, Poll {
            id: 0u32,
            creator: aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq0g,
            yes_votes: 0u32,
            no_votes: 0u32,
            is_active: false,
        });

        assert_eq(poll.creator, self.caller);
        
        poll.is_active = false;
        polls.set(poll_id, poll);
        return poll;
    }
}
