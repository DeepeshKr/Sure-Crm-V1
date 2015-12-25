xml.instruct!
xml.campaign_playlists do
     xml.name book.name
     xml.author book.author
     xml.price number_to_currency book.price
     xml.active book.active
end
