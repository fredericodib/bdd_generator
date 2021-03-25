# frozen_string_literal: true

class BddGeneratorParser
  def self.build
    file = File.open('features/bdd_generator_logs.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    File.open('features/bdd_generator.feature', 'w') do |f|
      f.write "Feature: bdd_generator\n\n"

      i = 0
      while i < file_data.size
        if file_data[i] != ''
          if file_data[i] == 'new_test:'
            i += 1
            controller = file_data[i].split(' ')[1]
            i += 1
            action = file_data[i].split(' ')[1]
            i += 1
            params = file_data[i].split(' ', 2)[1]
            i += 1
            headers = file_data[i].split(' ', 2)[1]
            i += 1
            path = file_data[i].split(' ')[1]
            i += 1
            method = file_data[i].split(' ')[1]
            i += 1
            i += 1

            f.write "\tScenario: #{controller} #{action}\n"
            while file_data[i].split(' ')[0] != 'status:'
              data = file_data[i].split(' ', 3)
              f.write "\t\tGiven There is an instance of #{data[0]} with id #{data[1]} and params: #{data[2]}\n"
              i += 1
            end
            f.write "\t\tWhen the client requests with #{method} #{path}, body: #{params}, headers: #{headers}\n"

            status = file_data[i].split(' ')[1]
            f.write "\t\tThen the response status should be #{status}\n"
            i += 1
            i += 1

            response = file_data[i]
            f.write "\t\tAnd The JSON response should be #{response}\n"

            f.write "\n"
          end
        end
        i += 1
      end
    end
  end
end
