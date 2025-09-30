#!/bin/bash

# Script para generar íconos de la aplicación usando el logo
echo "🎨 Generando íconos de la aplicación Paciente 360..."

# Verificar que existe el logo
LOGO_PATH="assets/images/logo 360.png"
if [ ! -f "$LOGO_PATH" ]; then
    echo "❌ Error: No se encontró el logo en $LOGO_PATH"
    exit 1
fi

echo "✅ Logo encontrado: $LOGO_PATH"

# Crear directorios para los íconos
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

# Función para redimensionar imagen usando sips (macOS)
resize_icon() {
    local input="$1"
    local output="$2"
    local size="$3"
    
    if command -v sips >/dev/null 2>&1; then
        sips -z $size $size "$input" --out "$output"
        echo "✅ Generado: $output (${size}x${size})"
    else
        echo "❌ Error: sips no está disponible. Instala ImageMagick o usa otra herramienta."
        return 1
    fi
}

# Generar íconos para Android
echo "📱 Generando íconos para Android..."

# HDPI (72x72)
resize_icon "$LOGO_PATH" "android/app/src/main/res/mipmap-hdpi/ic_launcher.png" 72

# MDPI (48x48)
resize_icon "$LOGO_PATH" "android/app/src/main/res/mipmap-mdpi/ic_launcher.png" 48

# XHDPI (96x96)
resize_icon "$LOGO_PATH" "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png" 96

# XXHDPI (144x144)
resize_icon "$LOGO_PATH" "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" 144

# XXXHDPI (192x192)
resize_icon "$LOGO_PATH" "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" 192

# Generar íconos para iOS
echo "🍎 Generando íconos para iOS..."

# Crear directorios para iOS
mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset

# Tamaños de íconos para iOS
declare -A ios_sizes=(
    ["20x20"]="20"
    ["29x29"]="29"
    ["40x40"]="40"
    ["58x58"]="58"
    ["60x60"]="60"
    ["76x76"]="76"
    ["80x80"]="80"
    ["87x87"]="87"
    ["120x120"]="120"
    ["152x152"]="152"
    ["167x167"]="167"
    ["180x180"]="180"
    ["1024x1024"]="1024"
)

for size_name in "${!ios_sizes[@]}"; do
    size="${ios_sizes[$size_name]}"
    output="ios/Runner/Assets.xcassets/AppIcon.appiconset/icon_${size_name}.png"
    resize_icon "$LOGO_PATH" "$output" "$size"
done

# Crear Contents.json para iOS
cat > ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json << 'EOF'
{
  "images" : [
    {
      "filename" : "icon_20x20.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "icon_20x20.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "icon_29x29.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "icon_29x29.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "icon_40x40.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "icon_40x40.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "icon_60x60.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "icon_60x60.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "icon_20x20.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "icon_20x20.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "icon_29x29.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "icon_29x29.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "icon_40x40.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "icon_40x40.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "icon_76x76.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "76x76"
    },
    {
      "filename" : "icon_76x76.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "icon_83.5x83.5.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "icon_1024x1024.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ Contents.json creado para iOS"

echo ""
echo "🎉 ¡Íconos generados exitosamente!"
echo ""
echo "📱 Android:"
echo "   - HDPI: 72x72"
echo "   - MDPI: 48x48"
echo "   - XHDPI: 96x96"
echo "   - XXHDPI: 144x144"
echo "   - XXXHDPI: 192x192"
echo ""
echo "🍎 iOS:"
echo "   - Múltiples tamaños desde 20x20 hasta 1024x1024"
echo ""
echo "🚀 Ahora puedes compilar la aplicación con los nuevos íconos:"
echo "   flutter build apk"
echo "   flutter build ios"
