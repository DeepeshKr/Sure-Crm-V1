class AddEmployeeIdToInteractionTranscripts < ActiveRecord::Migration
  def change
    add_column :interaction_transcripts, :employee_id, :integer
    add_column :interaction_transcripts, :ip, :string
  end
end
