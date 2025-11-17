from PySide6.QtWidgets import QGraphicsView, QGraphicsScene
from .tile_renderer import TileRenderer
from PySide6.QtCore import Qt

class DEMViewer(QGraphicsView):
    def __init__(self, dem, tile_cache):
        super().__init__()
        self.dem = dem
        self.tile_cache = tile_cache
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        self.tiles_items = {}
        self.scale_factor = 1.15  # zoom factor
        self.render_tiles()

        # Enable mouse dragging
        self.setDragMode(QGraphicsView.ScrollHandDrag)

    def render_tiles(self):
        for tx, ty in self.tile_cache.tile_coords():
            tile = self.tile_cache.get_tile(tx, ty)
            pixmap = TileRenderer.render(tile)
            if pixmap is None:
                continue
            if (tx, ty) in self.tiles_items:
                self.scene.removeItem(self.tiles_items[(tx, ty)])
            item = self.scene.addPixmap(pixmap)
            item.setPos(tx * self.tile_cache.tile_size, ty * self.tile_cache.tile_size)
            self.tiles_items[(tx, ty)] = item

    def wheelEvent(self, event):
        """Zoom in/out centered on cursor"""
        old_pos = self.mapToScene(event.position().toPoint())
        zoom_in = event.angleDelta().y() > 0
        zoom = self.scale_factor if zoom_in else 1 / self.scale_factor
        self.scale(zoom, zoom)
        new_pos = self.mapToScene(event.position().toPoint())
        delta = new_pos - old_pos
        self.translate(delta.x(), delta.y())
