import socket
import threading

clients = []


def server_thread(port):
    fd = socket.socket()
    fd.bind(("localhost", port))
    fd.listen(5)
    while True:
        client, _ = fd.accept()
        clients.append(client)


class Logger:
    @staticmethod
    def init(port):
        th = threading.Thread(target=server_thread, args=(port,))
        th.start()

    @staticmethod
    def log(msg):
        for client in clients:
            try:
                client.sendall((msg + "\n").encode())
            except Exception as e:
                print(e)
                pass
