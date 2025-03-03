program token_vesting.aleo {
    // Token vesting için kayıt yapısı
    record VestingSchedule {
        owner: address,
        token_amount: u64,
        start_time: u64,
        end_time: u64,
        claimed_amount: u64,
    }

    // Mapping'ler
    mapping claims: address => u64;

    // Vesting programı oluşturma
    transition create_vesting(
        receiver: address,
        token_amount: u64,
        start_time: u64,
        vesting_duration: u64,
    ) -> VestingSchedule {
        // Vesting bitiş zamanını hesapla
        let end_time: u64 = start_time + vesting_duration;

        // Yeni vesting schedule oluştur
        return VestingSchedule {
            owner: receiver,
            token_amount: token_amount,
            start_time: start_time,
            end_time: end_time,
            claimed_amount: 0u64,
        };
    }

    // Kilitlenen tokenleri talep etme
    transition claim(schedule: VestingSchedule) -> VestingSchedule {
        // Şu anki zamanı al (block height kullanılabilir)
        let current_time: u64 = ChainInfo::block_height();
        
        // Vesting durumunu kontrol et
        assert(current_time >= schedule.start_time);
        
        // Talep edilebilir miktarı hesapla
        let vesting_duration: u64 = schedule.end_time - schedule.start_time;
        let elapsed_time: u64 = current_time - schedule.start_time;
        
        let claimable_amount: u64 = 0u64;
        if (current_time >= schedule.end_time) {
            claimable_amount = schedule.token_amount - schedule.claimed_amount;
        } else {
            claimable_amount = (schedule.token_amount * elapsed_time) / vesting_duration - schedule.claimed_amount;
        }
        
        // Talep edilen miktarı güncelle
        let new_claimed_amount: u64 = schedule.claimed_amount + claimable_amount;
        
        // Claims mapping'ini güncelle
        Mapping::set(claims, self.caller, new_claimed_amount);
        
        // Güncellenmiş schedule'ı döndür
        return VestingSchedule {
            owner: schedule.owner,
            token_amount: schedule.token_amount,
            start_time: schedule.start_time,
            end_time: schedule.end_time,
            claimed_amount: new_claimed_amount,
        };
    }
} 