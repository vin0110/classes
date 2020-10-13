// IMPORT Python3 AS Python;

// tftest := EMBED(Python)
//     import tensorflow as tf
//     import numpy as np

//     # Create 100 phony x, y data points in NumPy, y = x * 0.1 + 0.3

//     x_data = np.random.rand(100).astype(np.float32)
//     y_data = x_data * 0.1 + 0.3

//     # Try to find values for W and b that compute y_data = W * x_data + b
//     # (We know that W should be 0.1 and b 0.3, but TensorFlow will
//     # figure that out for us.)

//     W = tf.Variable(tf.random_uniform([1], -1.0, 1.0))
//     b = tf.Variable(tf.zeros([1]))
//     y = W * x_data + b

//     # Minimize the mean squared errors.

//     loss = tf.reduce_mean(tf.square(y - y_data))
//     optimizer = tf.train.GradientDescentOptimizer(0.5)
//     train = optimizer.minimize(loss)

//     # Before starting, initialize the variables.  We will 'run' this first.
//     init = tf.initialize_all_variables()

//     # Launch the graph.

//     sess = tf.Session()
//     sess.run(init)

//     # Fit the line.

//     for step in range(201):
//         sess.run(train)
//         if step % 20 == 0:
//             print(step, sess.run(W).tolist()[0], sess.run(b).tolist()[0])

//     # Learns best fit is W: [0.1], b: [0.3]

//     print(sess.run(W).tolist()[0], sess.run(b).tolist()[0])
// ENDEMBED;

// // And here is the ECL code that evaluates the embed:

// tftest;


// IMPORT GNN.Tensor;

// tensData1 := DATASET([{[1,2], 1}, // This is the second cell
//                          {[2,1], 2}, // Third cell
//                          {[2,2], 3}], // Fourth cell 
//                          Tensor.R4.TensData);

// myTensor := Tensor.R4.MakeTensor([2,2], tensData1);

// tensData2 := Tensor.R4.GetData(myTensor);

// tensData2;

IMPORT GNN.GNNI;


s := GNNI.GetSession();

ldef := ['''layers.Dense(256, activation='tanh', input_shape=(5,))''',
         '''layers.Dense(256, activation='relu')''',
         '''layers.Dense(1, activation=None)'''];

compileDef := '''compile(optimizer=tf.keras.optimizers.SGD(.05),
                 loss=tf.keras.losses.mean_squared_error,
                 metrics=[tf.keras.metrics.mean_squared_error]) ''';

mod := GNNI.DefineModel(s, ldef, compileDef);

mod2 := GNNI.Fit(mod, trainX, trainY, batchSize := 128, numEpochs := 5);

initialWts := GNNI.GetWeights(mod);  // The untrained model weights

trainedWts := GNNI.GetWeights(mod2);  // The trained model weights

metrics := GNNI.EvaluateMod(mod2, testX, testY);

preds := GNNI.Predict(mod2, predX);

// import GNN.test as test;

// test.setuptest;