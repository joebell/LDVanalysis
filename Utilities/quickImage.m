function quickImage(matrix)

    h = image(matrix,'CDataMapping','scaled');
    set(gca,'YDir','normal');
    colorbar;