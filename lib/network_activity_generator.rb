require 'socket'

class NetworkActivityGenerator

  def generate_network_activity(destination_address, destination_port, data, logger)
    begin
      establish_connection(destination_address, destination_port)
      send_data(data)
      log_network_activity(destination_address, destination_port, data, 'TCP', logger)
    ensure
      close_connection
    end
  end

  def establish_connection (destination_address, destination_port)
    @socket = TCPSocket.open(destination_address, destination_port)
  end

  def send_data (data)
    @socket.puts(data)
  end

  def log_network_activity(destination_address, destination_port, data, protocol, logger)
    source_address = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
    local_address = @socket.local_address
    source_port = local_address.ip_port

    activity_details = {
      'destination_address' => destination_address,
      'destination_port' => destination_port,
      'source_address' => source_address,
      'source_port' => source_port,
      'amount_of_data_sent' => data.length,
      'protocol_of_data_sent' => protocol,
    }

    logger.log_activity('transmit_data', activity_details)
  end

  def close_connection
    @socket&.close
  end
end
