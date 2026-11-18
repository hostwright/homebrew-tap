class Hostwright < Formula
  desc "Mac-native desired-state control plane for Apple container workloads"
  homepage "https://hostwright.dev"
  url "https://github.com/hostwright/hostwright/releases/download/v0.0.2/hostwright-0.0.2-macos-arm64-9df19732120d.zip"
  version "0.0.2"
  sha256 "f92922c7b631bc713dbb68812cffb1478a57144b7da70d8464293644e13e6118"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    executables = %w[
      hostwright
      hostwright-control
      hostwright-containerization-helper
      hostwright-network-helper
      hostwright-network-provider-worker
      hostwright-storage-helper
      hostwright-dist
      hostwrightd
    ]
    executables.each do |name|
      system "/usr/bin/codesign", "--verify", "--strict", "--verbose=2", "bin/#{name}"
    end
    bin.install executables.map { |name| "bin/#{name}" }
    system "/usr/bin/codesign", "--verify", "--strict", "--verbose=2", "libexec/hostwright/Hostwright.app"
    libexec.install "libexec/hostwright"
    documentation = %w[
      share/doc/hostwright/LICENSE
      share/doc/hostwright/README.md
      share/doc/hostwright/THIRD_PARTY_NOTICES
      share/doc/hostwright/runtime-license-inventory.json
      share/doc/hostwright/third-party-license-inventory.json
    ]
    doc.install documentation
    pkgshare.install "share/hostwright/examples/hostwright.yaml"
    pkgshare.install "share/hostwright/containerization"
  end

  service do
    run [opt_bin/"hostwrightd", "--foreground", "--config", etc/"hostwright/hostwright.yaml"]
    keep_alive crashed: true
    working_dir var
    log_path var/"log/hostwrightd.log"
    error_log_path var/"log/hostwrightd.error.log"
  end

  def caveats
    <<~EOS
      Hostwright is installed without starting its service. To use hostwrightd,
      place a reviewed Manifest v3 file at:
        #{etc}/hostwright/hostwright.yaml
      An example is installed at:
        #{pkgshare}/hostwright.yaml
      Before starting the service for the first time, declare the installed identities:
        #{opt_bin}/hostwright daemon bootstrap-identities
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hostwright --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwright-control --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwright-containerization-helper --version").strip
    assert_equal "network-helper-protocol-v1", shell_output("#{bin}/hostwright-network-helper --version").strip
    assert_equal "network-provider-spi-v1", shell_output("#{bin}/hostwright-network-provider-worker --version").strip
    storage_helper_version = shell_output("#{bin}/hostwright-storage-helper --version").strip
    assert_equal "1.0.0", storage_helper_version
    assert_equal version.to_s, shell_output("#{bin}/hostwright-dist --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwrightd --version").strip
    assert_path_exists pkgshare/"containerization/kernel/vmlinux-6.18.55-186"
    assert_path_exists pkgshare/"containerization/vminit/index.json"
    assert_path_exists libexec/"hostwright/Hostwright.app/Contents/MacOS/hostwright-desktop"
  end
end
