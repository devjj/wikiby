module URLComponents
  URL_CHARS = ('0'..'9').to_a + %w(b c d f g h j k l m n p q r s t v w x y z) + %w(B C D F G H J K L M N P Q R S T V W X Y Z - _)
  URL_BASE = URL_CHARS.size
  
  def generate_slug(text, delimiter = '-')
    slug = text.downcase.gsub(/[^0-9a-z_ -]/i, '')
    slug = slug.gsub(/\s+/, delimiter)
    slug
  end
  
  def generate_tiny_url(id_number = self.id)
    local_count = id_number
    result = '';

    while local_count != 0
      rem = local_count % URL_BASE
      local_count = (local_count - rem) / URL_BASE
      result = URL_CHARS[rem] + result
    end

    return result
  end
end
