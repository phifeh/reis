#!/usr/bin/env python3
"""
Create a retro-themed app icon for reis (Portuguese for "travel journal")
Vintage camera aesthetic with warm retro colors
"""

# Use simple approach without PIL - create SVG and convert
import subprocess
import os

svg_content = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" xmlns="http://www.w3.org/2000/svg">
  <!-- Background - soft cream -->
  <rect width="512" height="512" fill="#F4F1DE" rx="80"/>
  
  <!-- Camera body - vintage orange -->
  <rect x="106" y="156" width="300" height="200" rx="20" fill="#E07A5F"/>
  
  <!-- Lens - deep taupe circle -->
  <circle cx="256" cy="256" r="80" fill="#3D405B"/>
  <circle cx="256" cy="256" r="60" fill="#81B29A" opacity="0.3"/>
  <circle cx="256" cy="256" r="40" fill="#3D405B"/>
  
  <!-- Viewfinder - top left -->
  <rect x="136" y="136" width="60" height="40" rx="8" fill="#3D405B"/>
  
  <!-- Flash - top right -->
  <rect x="316" y="136" width="60" height="40" rx="8" fill="#F2CC8F"/>
  
  <!-- Shutter button - top -->
  <circle cx="366" cy="186" r="16" fill="#E29578"/>
  
  <!-- "reis" text -->
  <text x="256" y="420" font-family="serif" font-size="56" font-weight="bold" 
        text-anchor="middle" fill="#3D405B" letter-spacing="4">reis</text>
</svg>'''

# Write SVG
with open('/tmp/reis_icon.svg', 'w') as f:
    f.write(svg_content)

print("SVG icon created")

# Try to convert using available tools
sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

base_path = '/Users/philipfehervari/projects/reis/android/app/src/main/res'

for density, size in sizes.items():
    output_path = f'{base_path}/{density}/ic_launcher.png'
    
    # Try rsvg-convert (best quality)
    try:
        subprocess.run([
            'rsvg-convert',
            '-w', str(size),
            '-h', str(size),
            '/tmp/reis_icon.svg',
            '-o', output_path
        ], check=True, capture_output=True)
        print(f"✓ Created {density}/ic_launcher.png ({size}x{size})")
        continue
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    
    # Try ImageMagick
    try:
        subprocess.run([
            'convert',
            '-background', 'none',
            '-resize', f'{size}x{size}',
            '/tmp/reis_icon.svg',
            output_path
        ], check=True, capture_output=True)
        print(f"✓ Created {density}/ic_launcher.png ({size}x{size})")
        continue
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    
    # Try qlmanage (macOS Quick Look)
    try:
        subprocess.run([
            'qlmanage',
            '-t',
            '-s', str(size),
            '-o', '/tmp',
            '/tmp/reis_icon.svg'
        ], check=True, capture_output=True, timeout=10)
        
        # Move the generated file
        subprocess.run([
            'mv',
            '/tmp/reis_icon.svg.png',
            output_path
        ], check=True)
        print(f"✓ Created {density}/ic_launcher.png ({size}x{size})")
        continue
    except (subprocess.CalledProcessError, FileNotFoundError, subprocess.TimeoutExpired):
        pass

print("\nIcon generation complete!")
print(f"SVG saved to: /tmp/reis_icon.svg")
