from builtin.string import String

fn get_unicode_piece(piece: Int) raises -> String:
    """
    Returns the fancy unicode symbol given the piece's integer representation.
    """
    if piece == ord('P'): return String('♙')
    elif piece == ord('N'): return String('♘')
    elif piece == ord('B'):return String('♗')
    elif piece == ord('R'):return String('♖')
    elif piece == ord('Q'):return String('♕')
    elif piece == ord('K'):return String('♔')
    elif piece == ord('p'):return String('♟')
    elif piece == ord('n'):return String('♞')
    elif piece == ord('b'):return String('♝')
    elif piece == ord('r'):return String('♜')
    elif piece == ord('q'):return String('♛')
    elif piece == ord('k'):return String('♚')
    else:raise Error('Invalid piece letter: ' + chr(piece))

fn get_unicode_piece(piece: String) raises -> String:
    """
    Returns the fancy unicode symbol given the piece's string representation.
    """
    if piece == 'P': return String('♙')
    elif piece == 'N': return String('♘')
    elif piece == 'B':return String('♗')
    elif piece == 'R':return String('♖')
    elif piece == 'Q':return String('♕')
    elif piece == 'K':return String('♔')
    elif piece == 'p':return String('♟')
    elif piece == 'n':return String('♞')
    elif piece == 'b':return String('♝')
    elif piece == 'r':return String('♜')
    elif piece == 'q':return String('♛')
    elif piece == 'k':return String('♚')
    else:raise Error('Invalid piece letter: ' + piece)

