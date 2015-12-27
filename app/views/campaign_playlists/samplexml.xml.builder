#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Codingfish"
    xml.author "Achim Fischer"
    xml.description "Software-Development, Mobiles Devices, Photography"
    xml.link "https://www.codingfish.com"
    xml.language "en"

    for article in @blog_articles
      xml.item do
        if article.title
          xml.title article.title
        else
          xml.title ""
        end
        xml.author "Achim Fischer"
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link "https://www.codingfish.com/blog/" + article.id.to_s + "-" + article.alias
        xml.guid article.id

        text = article.text
		# if you like, do something with your content text here e.g. insert image tags.
		# Optional. I'm doing this on my website.
        if article.image.exists?
            image_url = article.image.url(:large)
            image_caption = article.image_caption
            image_align = ""
            image_tag = "
                <p><img src='" + image_url +  "' alt='" + image_caption + "' title='" + image_caption + "' align='" + image_align  + "' /></p>
              "
            text = text.sub('{image}', image_tag)
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end
