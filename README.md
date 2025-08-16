# buildstation-sm
# 📘 Shared Inter-School Hash Registry (Aptos Move)

This project implements a **simple Aptos Move smart contract** that allows schools to register **hashes of student submissions** in order to detect **recycled or duplicate submissions** across the same registry, without exposing the actual content.

---

## 🚀 Features
- Each school has its **own registry** of submission hashes.
- Only **hashes** are stored, keeping original content private.
- Provides **two main functions**:
  1. **`init_registry`** → Initializes a hash registry for a school.
  2. **`register_submission`** → Registers a new submission hash and checks for duplicates.

---

## 📝 Contract Overview

```move
module SchoolRegistry::SubmissionHash {

    use std::signer;
    use std::vector;

    struct SubmissionStore has key {
        hashes: vector<vector<u8>>,
    }

    /// Initialize a school's registry (called once).
    public fun init_registry(account: &signer) {
        let store = SubmissionStore { hashes: vector::empty<vector<u8>>() };
        move_to(account, store);
    }

    /// Register a submission hash.
    /// Returns true if it's new, false if recycled.
    public fun register_submission(account: &signer, new_hash: vector<u8>): bool acquires SubmissionStore {
        let store = borrow_global_mut<SubmissionStore>(signer::address_of(account));
        let mut i = 0;
        let n = vector::length(&store.hashes);

        while (i < n) {
            if (vector::borrow(&store.hashes, i) == &new_hash) {
                return false; // Duplicate found
            };
            i = i + 1;
        };

        vector::push_back(&mut store.hashes, new_hash);
        true
    }
}

