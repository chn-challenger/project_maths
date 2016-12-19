module SerialNumber
  def generate_serial
    letters = [*'A'..'Z']
    digits = [*'0'..'9']
    serial_number = ''
    2.times { serial_number += letters.sample }
    6.times { serial_number += digits.sample }
    serial_number
  end
end
