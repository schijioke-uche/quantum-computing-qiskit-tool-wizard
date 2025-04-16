###   ⚛️ QUANTUM QISKIT TOOL INSTALLATION
######  By: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador & IBM Research
----------------------------------------------
The name "Qiskit" is a general term by IBM referring to a collection of software for executing programs on quantum computers. Most notably among these software tools is the open-source Qiskit SDK, and the runtime environment (accessed using Qiskit Runtime) through which you can execute workloads on IBM® quantum hardware. This installation wizard will allow you to install Qiskit software on your machine for IBM quantum development on real quantum QPU operator with realtime runtime. The installation is easy - It will prompt you to accept the license first and then it will automate the installation of qiskit tool for you.

### ⚛️ After Qiskit installation, you can run the following Quantum algorithms for various use cases

| Quantum Algorithm | Description |   Use Case   |
|-------------------|-------------|--------------|
| **Variational Quantum Eigensolver (VQE)** | A hybrid algorithm to approximate the ground state energy of a Hamiltonian. | Quantum chemistry, materials science, and molecular simulations. |
| **Quantum Approximate Optimization Algorithm (QAOA)** | Solves combinatorial optimization problems by mapping them to quantum circuits. | Route optimization, scheduling, and financial portfolio optimization. |
| **Harrow-Hassidim-Lloyd Algorithm (HHL)** | Solves linear systems of equations exponentially faster than classical algorithms in some cases. | Machine learning, numerical simulations, and optimization problems. |
| **Quantum Phase Estimation (QPE)** | Estimates the phase (eigenvalue) of a unitary operator. | Quantum chemistry, Shor's algorithm, and eigenvalue problems. |
| **Quantum Fourier Transform (QFT)** | The quantum analogue of the classical Fourier transform. | Shor’s algorithm, QPE, and signal processing. |
| **Grover's Search Algorithm** | Searches an unsorted database with quadratic speedup over classical algorithms. | Database search, unstructured search problems, and NP-complete problem approximations. |
| **Deutsch-Jozsa Algorithm** | Determines whether a Boolean function is constant or balanced using a single query. | Illustrates quantum speedup and is foundational in quantum algorithm theory. |
| **Bernstein–Vazirani Algorithm** | Finds a hidden binary string using a single evaluation of a function. | Speed-up in cryptographic analysis and quantum machine learning primitives. |
| **Shor’s Algorithm** | Efficiently factors large integers using quantum mechanics. | Cryptography, especially breaking RSA encryption. |
| **Quantum Walks** | Quantum analog of classical random walks, used for algorithmic speed-up. | Graph traversal, network analysis, and search algorithms. |

---

![IBM Quantum](./_media/q.png)

#### Before you start the installation, you need to have:
- Python v3.10+ Installed
- Operating system with 64bit (32bit OS is not supported by Qiskit)

#### STEPS

##### Step-1
```sh
git clone https://github.com/schijioke-uche/quantum-qiskit-startertool-wizard.git
```

##### Step-2: Change directory
```sh
cd quantum-qiskit-startertool-wizard
```

##### Step-3: Activate the quantum account enable file
```sh
cp quantum-accout.py.tpl quantum-account.py
```

##### Step-4:  Add the required field values then quit screen
```sh
vi quantum-account.py
```

##### Step-5: Run the install wizard
```sh
./qiskit-create-wizard.sh
```

----------------------------------------------

######  Removal of Installation
```sh
./qiskit-remove-wizard.sh
```

----------------------------------------------
#####  Author
###### Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador