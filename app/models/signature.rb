class Signature

  include ActiveModel::Validations
  include ActiveModel::Conversion

  extend ActiveModel::Naming

  include ActionView::Helpers::NumberHelper

  DEFAULTS = {
    twitter: 'EYDnAAPAC',
    linkedin_name: 'EY Analytics (Asia-Pacific)',
    linkedin_url: 'https://www.linkedin.com/company/ey-data-analytics/'
  }

  ADDRESSES = [
    { value: "8 Exhibition St. Melbourne VIC 3000", data: { country: "Australia" } },
    { value: "200 George St. Sydney NSW 2000", data: { country: "Australia" } },
    { value: "121 Marcus Clarke St. Canberra ACT 2600", data: { country: "Australia" } },
    { value: "Level 5, 121 King William St. Adelaide SA 5000", data: { country: "Australia" } },
    { value: "Level 51, 111 Eagle St. Brisbane QLD 4000", data: { country: "Australia" } },
    { value: "11 Mounts Bay Rd. Perth WA 6000", data: { country: "Australia" } },
    { value: "2 Takutai Square, Britomart Auckland 1010", data: { country: "New Zealand" } },
    { value: "Level 18 North Tower, One Raffles Quay 048583 Singapore", data: { country: "Singapore" } },
    { value: "10-2 Taeyoung Bldg. 3 to 8th Floor, Yeoido-dong, Youngdeungpo-gu 150777 Seoul", data: { country: "Republic of Korea" } },
    { value: "22/F, CITIC Tower, 1 Tim Mei Avenue Central", data: { country: "China" } },
    { value: "Level 23A, Menara Milenium, Jalan Damanlela Pusat Bandar Damansara 50490 Kuala Lumpur", data: { country: "Malaysia" } }
  ]

  COMPANIES = [
    { value: "EY Business Solutions Pty Ltd", data: { country: "Australia" } },
    { value: "EY Business Solutions (New Zealand) Ltd", data: { country: "New Zealand" } },
    { value: "Ernst & Young Solutions LLP", data: { country: "Singapore" } },
    { value: "Ernst & Young Advisory Inc.", data: { country: "Republic of Korea" } },
    { value: "Ernst & Young 安永", data: { country: "China" } },
    { value: "Ernst & Young Advisory Services Sdn", data: { country: "Malaysia" } },
    { value: "PT. Ernst & Young Indonesia", data: { country: "Indonesia" } }
  ]

  attr_accessor :name, :role, :phone, :email, :linkedin_url, :twitter, :address, :company,
    :assistant_name, :assistant_phone, :assistant_email

  validates :name, :role, :phone, :email, :address, :company, presence: true
  validates :assistant_phone, :assistant_email, :presence => true, :if => Proc.new { |r| r.assistant_name.present? }

  validates_each :email, :assistant_email do |record, attr, value|
    email = record.send(attr)
    next if email.blank?
    if email =~ /@(eyc3\.com|c3\.com\.au)$/
      record.errors.add(attr, 'must not be a legacy email address')
    end
    unless email =~ /@.*\.ey\.com$/
      record.errors.add(attr, 'must be a valid EY email address')
    end
  end

  def persisted?
    false
  end

  def initialize(attributes = {})
    attributes.each { |name, value| send "#{name}=", value } if attributes
  end

  def twitter=(value)
    @twitter = value.gsub(/\A@*/, '')
  end

  def twitter_name
    twitter_to_name twitter
  end

  def twitter_url
    twitter_to_url twitter
  end

  def phone_href
    "tel:#{phone.gsub(/\s/, '')}" if phone.present?
  end

  def assistant_phone_href
    "tel:#{assistant_phone.gsub(/\s/, '')}" if assistant_phone.present?
  end

  def logo_path
    'http://eyc3-email-assets.s3-website-ap-southeast-2.amazonaws.com/ey_dna.gif'
  end

protected

  def twitter_to_name(twitter)
    "@#{twitter}"
  end

  def twitter_to_url(twitter)
    URI::HTTPS.build(host: 'twitter.com', path: "/#{twitter}").to_s
  end

end

