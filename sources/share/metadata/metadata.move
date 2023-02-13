module shares::metadata {
    use sui::object::{UID, ID};
    use sui::tx_context::TxContext;
    use sui::object;
    use sui::event;

    friend shares::registry;

    struct ShareMetadata<phantom T> has key, store {
        id: UID,
        symbol: vector<u8>,
        name: vector<u8>,
    }

    struct ShareMetadataUpdated has copy, drop {
        id: ID,
        name: vector<u8>,
        symbol: vector<u8>
    }

    public(friend) fun create<T>(
        symbol: vector<u8>,
        name: vector<u8>,
        ctx: &mut TxContext
    ): ShareMetadata<T> {
        ShareMetadata {
            id: object::new(ctx),
            name,
            symbol
        }
    }

    public fun id<T>(metadata: &ShareMetadata<T>): ID {
        object::uid_to_inner(&metadata.id)
    }

    public fun update_name<T>(metadata: &mut ShareMetadata<T>, name: vector<u8>) {
        metadata.name = name;

        share_metadata_updated(metadata);
    }

    public fun update_symbol<T>(metadata: &mut ShareMetadata<T>, symbol: vector<u8>) {
        metadata.symbol = symbol;

        share_metadata_updated(metadata);
    }

    fun share_metadata_updated<T>(metadata: &ShareMetadata<T>) {
        event::emit(ShareMetadataUpdated {
            symbol: metadata.symbol,
            name: metadata.name,
            id: object::uid_to_inner(&metadata.id)
        })
    }
}