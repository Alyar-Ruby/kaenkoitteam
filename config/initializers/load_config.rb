APP_CONFIG = YAML.load_file("#{Rails.root}/config/instance.yml")['instance']
LANGUAGE = Array.new()
TIMEZONE = Array.new()
APP_CONFIG["languages"].each_pair { |key, value| LANGUAGE[key] = value }
APP_CONFIG["time_zones"].each_pair { |key, value| TIMEZONE[key] = value }

REASON_LIST = YAML.load_file("#{Rails.root}/config/refund_reason.yml")['instance']
REFUND_REASON = {}
REASON_LIST["reasons"].each_pair { |key, value| REFUND_REASON[key] = value }

