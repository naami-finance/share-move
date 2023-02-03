module naami::metadata_entries {
    use naami::metadata::{ShareMetadata};
    use naami::metadata;

    public entry fun update_name<T>(metadata: &mut ShareMetadata<T>, name: vector<u8>) {
        metadata::update_name(metadata, name);
    }

    public entry fun update_symbol<T>(metadata: &mut ShareMetadata<T>, symbol: vector<u8>) {
        metadata::update_symbol(metadata, symbol);
    }
}