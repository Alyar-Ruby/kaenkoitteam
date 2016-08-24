PHONECODE_LIST = YAML.load_file("#{Rails.root}/config/phone_code.yml")['instance']
PHONECOD = {}
PHONECODE_LIST["phone_codes"].each_pair { |key, value| PHONECOD[key] = value }
