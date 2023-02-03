module naami::registry {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    use sui::object::{UID, ID};
    use sui::object;
    use naami::bucket;
    use sui::types;
    use naami::metadata;
    use naami::bucket::ShareBucket;
    use std::type_name;
    use std::ascii::{Self};
    use sui::event;

    struct ShareRegistry<phantom T> has key, store {
        id: UID,
        total_supply: u64
    }

    struct ShareCreated has copy, drop {
        type: vector<u8>,
        symbol: vector<u8>,
        name: vector<u8>,
        total_supply: u64,
        registry_id: ID,
        metadata_id: ID
    }

    public fun total_supply<T>(registry: &ShareRegistry<T>): u64 {
        registry.total_supply
    }

    public fun create<T: drop>(
        witness: T,
        total_supply: u64,
        symbol: vector<u8>,
        name: vector<u8>,
        ctx: &mut TxContext
    ): ShareBucket<T> {
        assert!(types::is_one_time_witness(&witness), 0);

        let registryId = object::new(ctx);

        let metadata = metadata::create<T>(
            symbol,
            name,
            ctx
        );

        event::emit(ShareCreated {
            symbol,
            name,
            total_supply,
            type: ascii::into_bytes(type_name::into_string(type_name::get<T>())),
            registry_id: object::uid_to_inner(&registryId),
            metadata_id: metadata::id(&metadata)
        });

        transfer::share_object(ShareRegistry<T> {
            id: registryId,
            total_supply
        });

        transfer::transfer(metadata, tx_context::sender(ctx));

        bucket::create<T>(total_supply, ctx)
    }
}

