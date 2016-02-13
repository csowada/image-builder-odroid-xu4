require 'spec_helper'

# /proc/device-tree is only present if device-tree works
describe file('/proc/device-tree') do
  it { should be_owned_by 'root' }
end

describe file('/proc/device-tree/model') do
  it { should be_file }
  it { should be_mode 444 }
  it { should be_owned_by 'root' }
  its(:content) { should match /Hardkernel odroid-xu3 board based on EXYNOS5422/ }
end
