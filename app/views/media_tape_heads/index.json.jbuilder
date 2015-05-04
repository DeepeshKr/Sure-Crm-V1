json.array!(@media_tape_heads) do |media_tape_head|
  json.extract! media_tape_head, :id, :name, :description
  json.url media_tape_head_url(media_tape_head, format: :json)
end
