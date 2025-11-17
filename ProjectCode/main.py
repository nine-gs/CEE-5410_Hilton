from PySide6.QtWidgets import QApplication, QFileDialog
from ui.main_window import MainWindow

def run():
    app = QApplication([])

    path, _ = QFileDialog.getOpenFileName(
        None,
        "Open DEM",
        "",
        "DEM files (*.tif *.img *.hgt);;All files (*)"
    )
    if not path:
        return

    win = MainWindow(path)
    win.show()
    app.exec()

if __name__ == "__main__":
    run()
