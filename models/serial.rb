module SerialNumber

  def generate_serial
    letters, digits, serial_number = [*"A".."Z"], [*"0".."9"], ''
    2.times {serial_number += letters.sample}
    6.times {serial_number += digits.sample}
    serial_number
  end

end
