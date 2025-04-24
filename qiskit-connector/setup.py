from setuptools import setup, find_packages

setup(
    name="qiskit-connector",
    version="0.0.1",
    author="Dr. Jeffrey Chijioke-Uche",
    description="Qiskit 2.x Connector for IBM Quantum backends",
    py_modules=["qiskit_connector"],
    install_requires=[
        "requests>=2.25.0",
        "python-dotenv>=0.21.0",
        "qiskit-ibm-runtime>=0.37.0",
    ],
    include_package_data=True,
    python_requires=">=3.8",
)
