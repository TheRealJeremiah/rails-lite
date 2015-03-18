module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @res = res
      @req = req
      @rendered = false
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @rendered
    end

    # Set the response status code and header
    def redirect_to(url)
      raise "Don't double render!" if @rendered
      @rendered = true
      res.status = 302
      res.header['location'] = url
      res
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      raise "Don't double render!" if @rendered
      @rendered = true
      res.body = content
      res.content_type = content_type
      res
    end
  end
end
