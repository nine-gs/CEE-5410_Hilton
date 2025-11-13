import numpy as np
import pygame
from tifffile import imread
import tkinter as tk
from tkinter import filedialog

def hillshade(elevation, azimuth=315, altitude=45, cellsize=1):
    az = np.deg2rad(azimuth)
    alt = np.deg2rad(altitude)

    dy, dx = np.gradient(elevation, cellsize, cellsize)
    slope = np.pi/2 - np.arctan(np.hypot(dx, dy))
    aspect = np.arctan2(-dx, dy)
    aspect = np.where(aspect < 0, 2*np.pi + aspect, aspect)

    shade = (np.sin(alt) * np.sin(slope) +
             np.cos(alt) * np.cos(slope) * np.cos(az - aspect))
    return np.clip(shade, 0, 1)

def render_hillshade(elevation):
    shade = (hillshade(elevation) * 255).astype(np.uint8)
    rgb = np.repeat(shade[:, :, None], 3, axis=2)
    surf = pygame.surfarray.make_surface(np.transpose(rgb, (1, 0, 2)))

    pygame.init()
    screen = pygame.display.set_mode(surf.get_size())
    pygame.display.set_caption("Hillshade Viewer")
    clock = pygame.time.Clock()
    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
        screen.blit(surf, (0, 0))
        pygame.display.flip()
        clock.tick(30)
    pygame.quit()

def load_geotiff():
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(
        title="Select GeoTIFF",
        filetypes=[("TIFF files", "*.tif"), ("All files", "*.*")]
    )
    if not file_path:
        return None

    arr = imread(file_path)
    # If multi-band, take the first band
    if arr.ndim == 3:
        arr = arr[0]
    return arr.astype(float)

if __name__ == "__main__":
    elevation = load_geotiff()
    if elevation is not None:
        render_hillshade(elevation)
