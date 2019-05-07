{ stdenv, requireFile, unzip, cataclysmDDAPackages }:

with cataclysmDDAPackages;

buildCDDASoundPack rec {
  modName = "COAG";
  version = "1.1";

  src = requireFile rec {
    name = "CO.AG_SoundPack.zip";
    url = "https://drive.google.com/uc?id=1kjKQDOD0sYQY8QIH6fg8rgqEQgm8Bbqn";
    sha256 = "03qmgj595z21bcs0qf37ckj6dw2njbrklakm4qslanl41pd5ny9f";
  };

  nativeBuildInputs = [ unzip ];

  modRoot = ".";

  meta = with stdenv.lib; {
    description = "A C:DDA soundpack with the best dramatic and immersive post-apocalyptic atmosphere";
    homepage = "https://discourse.cataclysmdda.org/t/soundpack-co-ag-soundpack-v1-1-02-mar-19-only-the-music-alternative-addon/18992";
    license = licenses.cc-by-40;
    maintainers = [];
    platforms = platforms.all;
  };
}
