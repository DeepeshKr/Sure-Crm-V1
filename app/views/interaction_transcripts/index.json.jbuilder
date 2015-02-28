json.array!(@interaction_transcripts) do |interaction_transcript|
  json.extract! interaction_transcript, :id, :interactionid, :interactionuserid, :description
  json.url interaction_transcript_url(interaction_transcript, format: :json)
end
