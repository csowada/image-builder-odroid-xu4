require 'spec_helper'

describe file('/etc/os-release') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its(:content) { should match 'HYPRIOT_OS="HypriotOS/armhf"' }
  its(:content) { should match 'HYPRIOT_OS_VERSION="v0.7.1"' }
  its(:content) { should match 'HYPRIOT_DEVICE="ODROID XU4"' }
  its(:content) { should match 'HYPRIOT_IMAGE_VERSION=' }
end
