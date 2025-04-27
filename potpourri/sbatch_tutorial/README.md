# Simple Torch Test on SLURM

This project demonstrates how to:
- Run a simple neural network using PyTorch on a GPU (if available).
- Approximate the value of π (pi) using a Monte Carlo method.
- Submit the job to an HPC cluster managed by SLURM.

## Files

- `test.py` — Python script that defines and runs the network and approximates π.
- `test_script.sh` — SLURM batch script to submit `test.py` to the cluster.

## How to Run

1. **Prepare the Environment**  
   Load Python and PyTorch modules (adjust based on your cluster setup):

   ```bash
   module load python/3.9
   pip install torch --user  # Install PyTorch locally if not already availableo
   ```
2. **Submit the Job**
   Submit the SLURM job using:
   ```
   sbatch test_script.sh
   ```
3. **Output Files**
After the job completes, two files will be generated:
    ```
    test_job_<jobid>.out — Standard output log.
    
    test_job_<jobid>.err — Standard error log.
    ```

(<jobid> is automatically replaced with the SLURM Job ID.)
