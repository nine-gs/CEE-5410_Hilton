import numpy as np
import pygame
from tifffile import imread
import tkinter as tk
from tkinter import filedialog
import random

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
    if arr.ndim == 3:
        arr = arr[0]
    return arr.astype(float)

def render_hillshade(elevation):
    shade = (hillshade(elevation) * 255).astype(np.uint8)
    rgb = np.repeat(shade[:, :, None], 3, axis=2)

    pygame.init()
    screen = pygame.display.set_mode((800, 600), pygame.RESIZABLE)
    pygame.display.set_caption("Hillshade Viewer")
    clock = pygame.time.Clock()

    base_surface = pygame.surfarray.make_surface(np.transpose(rgb, (1, 0, 2)))
    img_width, img_height = base_surface.get_width(), base_surface.get_height()
    zoom = 1.0
    offset_x, offset_y = 0.0, 0.0
    dragging = False
    last_x, last_y = 0, 0
    min_zoom = max(10/img_width, 10/img_height)
    max_zoom = 3.0

    pointA = None
    pointB = None
    path = None
    paused = True
    current_cost = None
    test_paths = []

    scaled_surface = None
    last_zoom = None
    last_offset_x = None
    last_offset_y = None

    def compute_cost(points):
        total = 0.0
        for i in range(len(points)-1):
            x0, y0 = points[i]
            x1, y1 = points[i+1]
            h = np.hypot(x1 - x0, y1 - y0)
            e0 = elevation[int(y0), int(x0)]
            e1 = elevation[int(y1), int(x1)]
            v = max(0.0, e1 - e0)
            total += 2*h + v
        return total

    def apply_raindrops(points):
        path_length = np.sum([np.hypot(points[i+1][0]-points[i][0], points[i+1][1]-points[i][1])
                              for i in range(len(points)-1)])
        n_drops = random.randint(1,6)
        new_points = points.copy()
        drop_centers = []
        for _ in range(n_drops):
            center_idx = random.randint(0, len(points)-1)
            cx, cy = points[center_idx]
            radius = random.uniform(0.05*path_length, 0.2*path_length)
            intensity = random.uniform(0.5, 1.5)
            drop_centers.append((cx, cy, radius))
            for i, (px, py) in enumerate(new_points):
                dx = px - cx
                dy = py - cy
                dist = np.hypot(dx, dy)
                if dist <= radius:
                    gauss = np.exp(-0.5*(dist/radius)**2)
                    shift_x = dx / dist * intensity * gauss * 0.05 * path_length if dist != 0 else 0
                    shift_y = dy / dist * intensity * gauss * 0.05 * path_length if dist != 0 else 0
                    new_points[i] = (max(0, min(img_width-1, px+shift_x)),
                                     max(0, min(img_height-1, py+shift_y)))
        return new_points, drop_centers

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:
                    dragging = True
                    last_x, last_y = event.pos
                    sx, sy = event.pos
                    rx = int((sx - offset_x)/zoom)
                    ry = int((sy - offset_y)/zoom)
                    if pointA is None:
                        pointA = (rx, ry)
                    elif pointB is None:
                        pointB = (rx, ry)
                        path = [(pointA[0]+(pointB[0]-pointA[0])*k/200,
                                 pointA[1]+(pointB[1]-pointA[1])*k/200) for k in range(201)]
                        current_cost = compute_cost(path)
                        paused = False
                    else:
                        paused = not paused
            if event.type == pygame.MOUSEBUTTONUP and event.button == 1:
                dragging = False
            if event.type == pygame.MOUSEMOTION and dragging:
                dx = event.pos[0]-last_x
                dy = event.pos[1]-last_y
                offset_x += dx
                offset_y += dy
                last_x, last_y = event.pos
            if event.type == pygame.MOUSEWHEEL:
                mx, my = pygame.mouse.get_pos()
                old_zoom = zoom
                zoom *= 1.1 if event.y>0 else 0.9
                zoom = max(min_zoom, min(max_zoom, zoom))
                offset_x = mx-(mx-offset_x)*(zoom/old_zoom)
                offset_y = my-(my-offset_y)*(zoom/old_zoom)

        # Keep image in view
        w = int(img_width*zoom)
        h = int(img_height*zoom)
        offset_x = min(offset_x,0)
        offset_y = min(offset_y,0)
        offset_x = max(offset_x,screen.get_width()-w)
        offset_y = max(offset_y,screen.get_height()-h)

        if scaled_surface is None or zoom!=last_zoom or offset_x!=last_offset_x or offset_y!=last_offset_y:
            left = int(-offset_x/zoom)
            top = int(-offset_y/zoom)
            rect_w = int(screen.get_width()/zoom)+1
            rect_h = int(screen.get_height()/zoom)+1
            left = max(0,min(img_width-1,left))
            top = max(0,min(img_height-1,top))
            rect_w = min(rect_w,img_width-left)
            rect_h = min(rect_h,img_height-top)
            sub = base_surface.subsurface((left,top,rect_w,rect_h))
            scaled_surface = pygame.transform.scale(sub,(screen.get_width(),screen.get_height()))
            last_zoom, last_offset_x, last_offset_y = zoom, offset_x, offset_y

        # Optimization step
        drop_centers = []
        if path is not None and not paused:
            candidate, drop_centers = apply_raindrops(path)
            cand_cost = compute_cost(candidate)
            if cand_cost<current_cost:
                test_paths.append(candidate)
                path = candidate
                current_cost = cand_cost

        screen.fill((0,0,0))
        screen.blit(scaled_surface,(0,0))

        # Draw all tested paths in transparent green
        for t_path in test_paths:
            for i in range(len(t_path)-1):
                sx0 = int(t_path[i][0]*zoom+offset_x)
                sy0 = int(t_path[i][1]*zoom+offset_y)
                sx1 = int(t_path[i+1][0]*zoom+offset_x)
                sy1 = int(t_path[i+1][1]*zoom+offset_y)
                pygame.draw.line(screen,(0,255,0,100),(sx0,sy0),(sx1,sy1),1)

        # Draw current path in red
        if path is not None:
            for i in range(len(path)-1):
                sx0 = int(path[i][0]*zoom+offset_x)
                sy0 = int(path[i][1]*zoom+offset_y)
                sx1 = int(path[i+1][0]*zoom+offset_x)
                sy1 = int(path[i+1][1]*zoom+offset_y)
                pygame.draw.line(screen,(255,0,0),(sx0,sy0),(sx1,sy1),2)

        # Draw raindrops as light blue transparent circles
        for cx, cy, radius in drop_centers:
            surf = pygame.Surface((int(2*radius*zoom), int(2*radius*zoom)), pygame.SRCALPHA)
            for y in range(surf.get_height()):
                for x in range(surf.get_width()):
                    dx = x-radius*zoom
                    dy = y-radius*zoom
                    dist = np.hypot(dx, dy)
                    if dist<=radius*zoom:
                        alpha = int(80*np.exp(-0.5*(dist/(radius*zoom))**2))
                        surf.set_at((x,y),(0,0,255,alpha))
            screen.blit(surf,(int((cx-radius)*zoom+offset_x), int((cy-radius)*zoom+offset_y)))
            pygame.draw.circle(screen,(0,0,255), (int(cx*zoom+offset_x), int(cy*zoom+offset_y)), int(radius*zoom),1)

        # Display cost
        if current_cost is not None:
            font = pygame.font.SysFont(None,24)
            text_surf = font.render(f"{current_cost:.1f}",True,(255,255,255))
            rect = text_surf.get_rect()
            rect.bottomright=(screen.get_width()-10,screen.get_height()-10)
            screen.blit(text_surf,rect)

        pygame.display.flip()
        clock.tick(60)

    pygame.quit()


if __name__=="__main__":
    elevation = load_geotiff()
    if elevation is not None:
        render_hillshade(elevation)
