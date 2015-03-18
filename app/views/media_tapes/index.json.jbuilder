json.array!(@media_tapes) do |media_tape|
  json.extract! media_tape, :id, :name, :duration_secs, :tape_ext_ref_id, :unique_tape_name, :media_id, :product_variant_id, :description
  json.url media_tape_url(media_tape, format: :json)
end
