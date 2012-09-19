# @author 
class Controller
  @@default_headers = {
      'Content-Type' => 'application/json; charset=UTF-8'
  }

  def initialize
    @cache = {}
    @app = App.new
  end

  def example_action
    data = @app.example
    [200,@@default_headers, ['flats = ' << data.to_json]]
  end


end