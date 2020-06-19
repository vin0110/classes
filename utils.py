import numpy as np


class CustomScaler:
    '''scales the first `scaleCols` columns using scaler
    input is np.ndarray of shape [no_samples, width_of_a_sample, no_features]
    '''
    def __init__(self, scaler, scaleCols):
        self.scaler = scaler
        self.scaleCols = scaleCols

    def _apply(self, data, which):
        if len(data.shape) == 2:
            left = data[:, 0:self.scaleCols]
            right = data[:, self.scaleCols:]

            scaled = which(left)
            return np.concatenate((scaled, right), 1)
        elif len(data.shape) == 3:
            left = data[:, :, 0:self.scaleCols]
            right = data[:, :, self.scaleCols:]

            left2 = left.reshape(left.shape[0] * left.shape[1], left.shape)
            scaled = which(left2)
            scaled = scaled.reshape(left.shape)
            return np.concatenate((scaled, right), 2)
        else:
            raise ValueError('invalid shape %s', str(data.shape))

    def transform(self, data):
        return self._apply(data, self.scaler.transform)

    def inverse_transform(self, data):
        return self._apply(data, self.scaler.inverse_transform)
