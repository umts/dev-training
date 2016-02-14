module UMTSTraining
  class CLI < ::HighLine
    def pw_ask(prompt)
      ask(prompt) { |q| q.echo = '*' }
    end
  end
end
