// The 'aleo_calculator' program.
program aleo_calculator.aleo {
    // Toplama işlemi
    transition calculate_sum(public a: u32, public b: u32) -> u32 {
        return a + b;
    }

    // Çıkarma işlemi
    transition calculate_difference(public a: u32, public b: u32) -> u32 {
        return a - b;
    }

    // Çarpma işlemi
    transition calculate_product(public a: u32, public b: u32) -> u32 {
        return a * b;
    }

    // Bölme işlemi
    transition calculate_quotient(public a: u32, public b: u32) -> u32 {
        assert(b != 0u32); 
        return a / b;
    }
}
