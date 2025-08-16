module SchoolRegistry::SubmissionHash {

    use std::signer;
    use std::vector;

    /// Stores all submission hashes for a school.
    struct SubmissionStore has key {
        hashes: vector<vector<u8>>,   // Each entry is a hash of a submission
    }

    /// Initialize a school's registry (called once per school).
    public fun init_registry(account: &signer) {
        let store = SubmissionStore { hashes: vector::empty<vector<u8>>() };
        move_to(account, store);
    }

    /// Add a new submission hash; returns true if it's new, false if recycled.
    public fun register_submission(account: &signer, new_hash: vector<u8>): bool acquires SubmissionStore {
        let store = borrow_global_mut<SubmissionStore>(signer::address_of(account));

        // Check for duplicates
        let  i = 0;
        let n = vector::length(&store.hashes);
        while (i < n) {
            if (vector::borrow(&store.hashes, i) == &new_hash) {
                return false; // Already exists -> recycled
            };
            i = i + 1;
        };

        // If not found, add the new hash
        vector::push_back(&mut store.hashes, new_hash);
        true
    }
}
