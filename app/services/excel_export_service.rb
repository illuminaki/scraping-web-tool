# frozen_string_literal: true

require "write_xlsx"

# Service responsible for exporting list data to Excel format
class ExcelExportService
  HEADERS = [
    "Orden",
    "Nombre",
    "Número contacto",
    "Correo",
    "Descripción",
    "Sitio web",
    "Dirección",
    "Redes Sociales"
  ].freeze

  attr_reader :list, :output_path

  def initialize(list:, output_path: nil)
    @list = list
    @output_path = output_path || generate_output_path
  end

  def call
    create_workbook
    write_headers
    write_data
    close_workbook

    @output_path
  end

  private

  def generate_output_path
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    Rails.root.join("tmp", "exports", "#{list.name.parameterize}_#{timestamp}.xlsx").to_s
  end

  def create_workbook
    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(@output_path))

    @workbook = WriteXLSX.new(@output_path)
    @worksheet = @workbook.add_worksheet("Datos")

    # Define formats
    @header_format = @workbook.add_format(bold: true, bg_color: "#4472C4", color: "white")
    @cell_format = @workbook.add_format(text_wrap: true)
  end

  def write_headers
    HEADERS.each_with_index do |header, index|
      @worksheet.write(0, index, header, @header_format)
      @worksheet.set_column(index, index, column_width(index))
    end
  end

  def write_data
    @list.registers.each_with_index do |register, index|
      row = index + 1
      write_register_row(row, register)
    end
  end

  def write_register_row(row, register)
    @worksheet.write(row, 0, row, @cell_format)
    @worksheet.write(row, 1, register.title, @cell_format)
    @worksheet.write(row, 2, register.phones, @cell_format)
    @worksheet.write(row, 3, register.emails, @cell_format)
    @worksheet.write(row, 4, register.description, @cell_format)
    @worksheet.write(row, 5, register.website_url, @cell_format)
    @worksheet.write(row, 6, register.address, @cell_format)
    @worksheet.write(row, 7, format_social_networks(register.social_networks), @cell_format)
  end

  def format_social_networks(networks)
    return "" if networks.blank?

    networks.split(", ").map { |url| URI.encode_www_form_component(url) }.join(", ")
  rescue StandardError
    networks
  end

  def column_width(index)
    case index
    when 0 then 8   # Orden
    when 1 then 25  # Nombre
    when 2 then 20  # Teléfono
    when 3 then 30  # Correo
    when 4 then 40  # Descripción
    when 5 then 35  # Sitio web
    when 6 then 30  # Dirección
    when 7 then 40  # Redes Sociales
    else 15
    end
  end

  def close_workbook
    @workbook.close
  end
end
