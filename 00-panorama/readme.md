curl --location --request POST 'https://20.118.98.21/api' -k \
--header 'Authorization: Basic cGFuYWRtaW46Ml90Y21vcnZjdHpxeHkxSg==' \
--form 'type="config"' \
--form 'action="set"' \
--form 'xpath="/config/devices/entry[@name='\''localhost.localdomain'\'']/template-stack/entry[@name='\''sebstack'\'']/config/devices/entry[@name='\''localhost.localdomain'\'']/vsys/entry[@name='\''vsys1'\'']/redistribution-agent/entry[@name='\''cts'\'']"' \
--form 'element="<serial-number>panorama</serial-number><ip-tags>yes</ip-tags>"'