class Blissify < Formula
  desc "analyze an MPD library and make smart playlists"
  homepage "https://github.com/Polochon-street/blissify-rs"
  head "https://github.com/Polochon-street/blissify-rs.git", branch: "master"

  depends_on "rust" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "aubio"
  depends_on "sqlite"
  depends_on "nasm"

  def build
    system "cargo", "build", "--release"
  end

  test do
    system "#{bin}/blissify", "--help"
  end
end