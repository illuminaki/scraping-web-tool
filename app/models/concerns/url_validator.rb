# frozen_string_literal: true

# Configuration for excluded URLs that should not be scraped
# These are typically social networks, search engines, and other non-relevant sites
module UrlValidator
  extend ActiveSupport::Concern

  EXCLUDED_DOMAINS = %w[
    eltiempo.com
    medellin.gov.co
    instagram.com
    facebook.com
    elcolombiano.com
    linkedin.com
    google.com
    google.com.co
    google.com.ec
    wikipedia.org
    bogota.gov.co
    msn.com
    jooble.org
    elempleo.com
    mitula.com.co
    rcnradio.com
    computrabajo.com
    falabella.com
    girardota.gov.co
    mercadolibre.com.co
    airbnb.com
    airbnb.com.co
    airbnb.mx
    twitter.com
    teleantioquia.co
    concejodegirardota.gov.co
    indeed.com
    fincaraiz.com.co
    elmundo.com
    comfama.com
    hoteles.com
    caracoltv.com
    sena.edu.co
    prezi.com
    itm.edu.co
    youtube.com
    indergirardota.gov.co
    informeinmobiliario.com
    lasnoticiasenred.com
    cybo.com
    espaciourbano.com
    tripadvisor.co
    tripadvisor.es
    tripadvisor.com.ar
    tripadvisor.ie
    tripadvisor.co.nz
    booking.com
    kayak.com.co
    trivago.com.co
    trivago.com.ec
    despegar.com.co
    despegar.com.ar
    expedia.com
    atrapalo.com.co
    atrapalo.com
    ayenda.com
    tiktok.com
    policia.gov.co
    comfenalcoantioquia.com
    viajescomfama.com
    coonorte.com.co
    saludcapital.gov.co
    vrbo.com
    hotels.com
    bookabach.co.nz
    amarilo.com.co
    alojamiento.io
    mileroticos.com
    books.google.com.co
    elespectador.com
    todosnegocios.com
    cinematecadebogota.gov.co
    somospais.co
    losmejorescolegios.com
    casapropiacolombia.com
    trovit.com.co
    minuto30.com
    compensar.com
    axacolpatria.co
    minsalud.gov.co
    invima.gov.co
    udea.edu.co
    colmenaseguros.com
    ukucela.com
    metrocuadrado.com
  ].freeze

  # Spam/suspicious domains
  SPAM_DOMAINS = %w[
    dimperi.online
    eklerist.online
    lipresd.online
    jupial.online
    asdcevi.online
    gilmera.online
    uhlirp.online
    onixers.online
  ].freeze

  class_methods do
    def excluded_domains
      EXCLUDED_DOMAINS + SPAM_DOMAINS
    end

    def url_excluded?(url)
      return true if url.blank?

      uri = URI.parse(url)
      domain = uri.host&.downcase&.gsub(/^www\./, '')

      excluded_domains.any? { |excluded| domain&.include?(excluded) }
    rescue URI::InvalidURIError
      true
    end

    def filter_urls(urls)
      urls.reject { |url| url_excluded?(url) }.uniq
    end
  end
end
