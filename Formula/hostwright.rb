class Hostwright < Formula
  desc "Mac-native desired-state control plane for Apple container workloads"
  homepage "https://hostwright.dev"
  url "https://github.com/hostwright/hostwright/releases/download/v0.0.2-dev.5/hostwright-0.0.2-dev.5-macos-arm64-da2d34494aa3.zip"
  version "0.0.2-dev.5"
  sha256 "b0828fe554facc51aec9a4bfe8957ea253c11ce182c72317c7090db5abcc034a"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    executables = %w[hostwright hostwright-control hostwright-dist hostwrightd]
    executables.each do |name|
      system "/usr/bin/codesign", "--verify", "--strict", "--verbose=2", "bin/#{name}"
    end
    bin.install executables.map { |name| "bin/#{name}" }
    doc.install "share/doc/hostwright/LICENSE", "share/doc/hostwright/README.md"
    pkgshare.install "share/hostwright/examples/hostwright.yaml"
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
      place a reviewed v2 manifest at:
        #{etc}/hostwright/hostwright.yaml
      An example is installed at:
        #{pkgshare}/hostwright.yaml
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hostwright --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwright-control --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwright-dist --version").strip
    assert_equal version.to_s, shell_output("#{bin}/hostwrightd --version").strip
    capabilities = shell_output("#{bin}/hostwright capabilities --json")
    assert_match '"schemaVersion":1', capabilities
    assert_match '"productVersion":"0.0.2-dev.5"', capabilities
  end
end
